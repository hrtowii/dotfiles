package main

import (
	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/log"
)

// Model holds the state of the program
type Model struct {
	Messages  []string
	APIURL    string
	APIToken  string
	UserInput string
}

// NewModel creates a new Model instance
func NewModel(apiURL, apiToken string) Model {
	return Model{
		APIURL:   apiURL,
		APIToken: apiToken,
	}
}

// Update handles events and updates the model
func (m Model) Update(msg bubbletea.Msg) (bubbletea.Model, bubbletea.Cmd) {
	switch msg := msg.(type) {
	case bubbletea.KeyMsg:
		if msg.String() == "enter" {
			m.Messages = append(m.Messages, "You: "+m.UserInput)
			// Send user input to API and start streaming response
			go func() {
				// Here you would make the API request and stream the response
				// For demonstration, we'll simulate a response
				response := "AI: Hello! How can I assist you today?"
				m.Messages = append(m.Messages, response)
				// Send a message to the program to update the view
				m.Program().Post(msg)
			}()
			m.UserInput = ""
			return m, bubbletea.ClearInput()
		}
	case "ctrl+c":
		return m, bubbletea.Quit
	default:
		m.UserInput += string(msg.Rune())
		return m, nil
	}
	return m, nil
}

// View renders the UI
func (m Model) View() string {
	s := ""
	for _, msg := range m.Messages {
		s += msg + "\n"
	}
	prompt := lipgloss.NewStyle().Foreground(lipgloss.Color("203")).Render("Prompt: ")
	return s + prompt + m.UserInput
}

// Initialize the program
func (m Model) Init() bubbletea.Cmd {
	return nil
}

// Run the program
func main() {
	apiURL := "https://api.openai.com/v1/chat/completions"
	apiToken := "your-openai-api-key"

	model := NewModel(apiURL, apiToken)

	p := bubbletea.NewProgram(model)
	p.Use(bubbletea.InputDelegate{
		IgnoreCtrlC: true,
	})

	if err := p.Run(); err != nil {
		log.Fatal(err)
	}
}
