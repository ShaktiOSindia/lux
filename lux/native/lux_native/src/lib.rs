#[rustler::nif]
fn evaluate(task: String, input: String) -> String {
    format!("Rust processed task: '{}' with input: '{}'", task, input)
}

rustler::init!("Elixir.Lux.Rust");
