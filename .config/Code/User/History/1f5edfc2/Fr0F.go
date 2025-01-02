package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"strings"

	"encoding/json"
	"net/http"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/log"
)

// Message represents a single chat message with role and content
type Message struct {
	Role    string
	Content string
}

// Custom message types for communication
type AIResponseMsg string
type StreamEndMsg struct{}
type ErrorMessage string

// Model holds the state of the program
type Model struct {
	Messages                []Message
	CurrentAssistantMessage Message
	IsStreaming             bool
	APIURL                  string
	APIToken                string
	UserInput               string
	ModelName               string
}

// Update handles events and updates the model
func (m Model) Update(msg bubbletea.Msg) (bubbletea.Model, bubbletea.Cmd) {
	var cmd bubbletea.Cmd
	switch msg := msg.(type) {
	case bubbletea.KeyMsg:
		if m.IsStreaming {
			return m, tea.Batch()
		}
		if msg.String() == "enter" {
			if m.UserInput == "" {
				return m, nil
			}
			m.Messages = append(m.Messages, Message{Role: "user", Content: m.UserInput})
			m.CurrentAssistantMessage = Message{Role: "assistant", Content: ""}
			m.IsStreaming = true
			return m, bubbletea.Command(func() {
				sendAPIRequest(m, m.Program())
			})
		}
	case AIResponseMsg:
		if m.IsStreaming {
			m.CurrentAssistantMessage.Content += string(msg)
			return m, nil
		}
	case StreamEndMsg:
		if m.IsStreaming {
			m.Messages = append(m.Messages, m.CurrentAssistantMessage)
			m.IsStreaming = false
			m.CurrentAssistantMessage = Message{}
			return m, nil
		}
	case ErrorMessage:
		m.Messages = append(m.Messages, Message{Role: "system", Content: string(msg)})
		return m, nil
	}
	if m.IsStreaming {
		return m, bubbletea.DisableInput()
	}
	return m, nil
}

// View renders the UI
func (m Model) View() string {
	var s strings.Builder
	for _, msg := range m.Messages {
		s.WriteString(fmt.Sprintf("%s: %s\n", msg.Role, msg.Content))
	}
	if m.IsStreaming {
		s.WriteString(fmt.Sprintf("%s: %s", m.CurrentAssistantMessage.Role, m.CurrentAssistantMessage.Content))
	}
	prompt := lipgloss.NewStyle().Foreground(lipgloss.Color("203")).Render("\nPrompt: ")
	s.WriteString(prompt + m.UserInput)
	return s.String()
}

// sendAPIRequest handles the API call and streams response
func sendAPIRequest(m Model, p *bubbletea.Program) {
	if p == nil {
		log.Error("Program not set")
		return
	}
	// Construct request body
	messages := make([]map[string]string, len(m.Messages))
	for i, msg := range m.Messages {
		messages[i] = map[string]string{
			"role":    msg.Role,
			"content": msg.Content,
		}
	}
	reqBody := map[string]interface{}{
		"model":    m.ModelName,
		"messages": messages,
		"stream":   true,
	}
	reqJSON, err := json.Marshal(reqBody)
	if err != nil {
		p.Post(ErrorMessage(err.Error()))
		return
	}
	// Create HTTP POST request
	req, err := http.NewRequest("POST", m.APIURL, bytes.NewBuffer(reqJSON))
	if err != nil {
		p.Post(ErrorMessage(err.Error()))
		return
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", m.APIToken))
	// Make the request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		p.Post(ErrorMessage(err.Error()))
		return
	}
	defer resp.Body.Close()
	// Read response body
	scanner := bufio.NewScanner(resp.Body)
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "data: ") {
			jsonStr := strings.TrimPrefix(line, "data: ")
			if jsonStr == "[DONE]" {
				p.Post(StreamEndMsg{})
				break
			}
			var data map[string]interface{}
			err := json.Unmarshal([]byte(jsonStr), &data)
			if err != nil {
				p.Post(ErrorMessage(err.Error()))
				continue
			}
			delta, ok := data["delta"].(map[string]interface{})
			if !ok {
				continue
			}
			content, ok := delta["content"].(string)
			if !ok {
				continue
			}
			p.Post(AIResponseMsg(content))
		}
	}
	if err := scanner.Err(); err != nil {
		p.Post(ErrorMessage(err.Error()))
	}
}

// Run the program
func main() {
	apiURL := "https://api.openai.com/v1/chat/completions"
	apiToken := os.Getenv("OPENAI_API_KEY")
	if apiToken == "" {
		log.Fatal("API key not set")
	}
	modelName := "gpt-3.5-turbo"

	model := Model{
		APIURL:    apiURL,
		APIToken:  apiToken,
		ModelName: modelName,
	}

	p := bubbletea.NewProgram(model)
	p.Use(bubbletea.InputDelegate{
		IgnoreCtrlC: true,
	})

	if err := p.Run(); err != nil {
		log.Fatal(err)
	}
}
