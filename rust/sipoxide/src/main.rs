#[macro_use]
extern crate serde_derive;
extern crate serde;

use std::fs;

mod bov;

fn main() {
    let contents = fs::read_to_string("./data/root.json")
        .expect("Something went wrong reading the file").to_string();

    let ds: Vec<bov::Root> = serde_json::from_str(&contents).unwrap();

    for s in ds.iter() {
        for e in s.events.iter() {
            println!("{}", e.id)
        }
    }
}