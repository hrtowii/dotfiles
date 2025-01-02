use std::io;
use tui::{
    backend::CrosstermBackend,
    layout::{Constraint, Direction, Layout},
    style::{Color, Style},
    text::{Span, Spans},
    widgets::{Block, Borders, Paragraph},
    Terminal,
};
use crossterm::{
    event::{self, Event, KeyCode},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use reqwest::Client;
use serde::Deserialize;
use tokio::sync::mpsc;

#[derive(Deserialize)]
struct ApiResponse {
    choices: Vec<Choice>,
}

#[derive(Deserialize)]
struct Choice {
    text: String,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Setup terminal
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    // Create a channel for communication between the TUI and the API task
    let (tx, mut rx) = mpsc::channel(32);

    // Spawn a task to handle API requests
    let client = Client::new();
    tokio::spawn(async move {
        loop {
            let input = rx.recv().await.unwrap();
            let response = client
                .post("https://api.openai.com/v1/completions")
                .json(&serde_json::json!({
                    "prompt": input,
                    "max_tokens": 50,
                    "model": "text-davinci-003"
                }))
                .send()
                .await
                .unwrap()
                .json::<ApiResponse>()
                .await
                .unwrap();

            let text = response.choices[0].text.clone();
            tx.send(text).await.unwrap();
        }
    });

    // Main loop
    let mut input = String::new();
    let mut output = String::new();
    loop {
        terminal.draw(|f| {
            let chunks = Layout::default()
                .direction(Direction::Vertical)
                .constraints(
                    [
                        Constraint::Percentage(80),
                        Constraint::Percentage(20),
                    ]
                    .as_ref(),
                )
                .split(f.size());

            let output_block = Paragraph::new(output.as_ref())
                .block(Block::default().borders(Borders::ALL).title("Output"));
            f.render_widget(output_block, chunks[0]);

            let input_block = Paragraph::new(input.as_ref())
                .block(Block::default().borders(Borders::ALL).title("Input"));
            f.render_widget(input_block, chunks[1]);
        })?;

        if let Event::Key(key) = event::read()? {
            match key.code {
                KeyCode::Char(c) => {
                    input.push(c);
                }
                KeyCode::Backspace => {
                    input.pop();
                }
                KeyCode::Enter => {
                    tx.send(input.clone()).await.unwrap();
                    input.clear();
                }
                KeyCode::Esc => {
                    break;
                }
                _ => {}
            }
        }

        if let Ok(text) = rx.try_recv() {
            output = text;
        }
    }

    // Restore terminal
    disable_raw_mode()?;
    execute!(terminal.backend_mut(), LeaveAlternateScreen)?;
    terminal.show_cursor()?;

    Ok(())
}