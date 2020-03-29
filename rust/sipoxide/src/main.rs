#[macro_use]
extern crate serde_derive;
extern crate serde;
extern crate reqwest;
use reqwest::Error;

use std::fs;

mod bov;

fn parse() {

    let contents = fs::read_to_string("./data/root.json")
        .expect("Something went wrong reading the file").to_string();

    let ds: Vec<bov::Root> = serde_json::from_str(&contents).unwrap();

    for s in ds.iter() {
        for e in s.events.iter() {
            println!("{}", e.id)
        }
    }
    // Ok(())
}

fn main() {
    parse()

}

// fn grab() {

//     let url = "https://www.bovada.lv/services/sports/event/v2/events/A/description/";
    
//     println!("getting {}", url);
    
//     let mut response = reqwest::get(url);
//     // let response = match response {
//     //     Ok(_) => response,
//     //     Err(error) => {
//     //         panic!("Problem opening the response: {:?}", error)
//     //     },
//     // };
//     let roots: Vec<bov::Root> = response.json();

//     println!("{:?}", roots);
//     Ok(())
// }