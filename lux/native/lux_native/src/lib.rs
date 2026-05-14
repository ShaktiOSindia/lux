use rustler::{Atom, Encoder, Env, Term};

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

#[rustler::nif]
fn evaluate<'a>(env: Env<'a>, task: String, input: Term<'a>) -> Term<'a> {
    match task.as_str() {
        "echo" => (atoms::ok(), input).encode(env),
        "sum" => {
            if let Ok(list) = input.decode::<Vec<i64>>() {
                let sum: i64 = list.iter().sum();
                (atoms::ok(), sum).encode(env)
            } else {
                (atoms::error(), "Input must be a list of integers").encode(env)
            }
        }
        "is_truthy" => {
            let result = if input.is_atom() {
                let s = input.atom_to_string().unwrap();
                s != "false" && s != "nil"
            } else if let Ok(b) = input.decode::<bool>() {
                b
            } else {
                true
            };
            (atoms::ok(), result).encode(env)
        }
        _ => (atoms::error(), format!("Unknown task: {}", task)).encode(env),
    }
}

rustler::init!("Elixir.Lux.Rust");
