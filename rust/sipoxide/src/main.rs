#[macro_use]
extern crate serde_derive;
extern crate serde;
// extern crate reqwest;
// use reqwest::Error;

use std::fs;

mod bov;

impl bov::Outcome {
    fn repr(&self) {
        println!("oc {} {}", self.description, self.price.decimal);
        // self.price.repr()
    }
}
impl bov::Market {
    fn repr(&self) {
        println!("{}", self.description);
        for o in self.outcomes.iter() {
            o.repr();
        }
    }
}
impl bov::DisplayGroup {
    fn repr(&self) {
        for m in self.markets.iter() {
            m.repr();
        }
    }
}

impl bov::Root {
    fn repr(&self) {
        for e in self.events.iter() {
            e.repr();
        }
    }

    fn count_events(&self) -> u64 {
        let mut n: u64 = 0;
        for e in self.events.iter() {
            n += 1;
        }
        return n;
    }
}

impl ToString for bov::Competitor {
    fn to_string(&self) -> String {
        return format!("Competitor {} {} {}", self.id, self.name, self.home);
    }
}
impl ToString for bov::Outcome {
    fn to_string(&self) -> String {
        return format!("oc {} {}", self.description, self.price.decimal);
    }
}
impl ToString for bov::Market {
    fn to_string(&self) -> String {
        return format!("mkt {} {}", self.id, self.description);
    }
}
impl ToString for bov::DisplayGroup {
    fn to_string(&self) -> String {
        return format!("oc {} {}", self.id, self.description);
    }
}
impl ToString for bov::Event {
    fn to_string(&self) -> String {
        return format!("ev {} {} {}", self.id, self.description, self.status);
    }
}

impl bov::Event {
    fn repr(&self) {
        println!("{} {} {}", self.id, self.description, self.sport);
        for c in self.competitors.iter() {
            println!("{}", c.to_string());
        }
        match &self.display_groups {
            Some(dgs) => dgs.iter().map(|x| x.repr()).collect::<Vec<_>>(),
            None => vec![],
        };
    }
}

fn parse() {
    let contents = fs::read_to_string("./data/root.json")
        .expect("Something went wrong reading the file")
        .to_string();

    let ds: Vec<bov::Root> = serde_json::from_str(&contents).unwrap();
    let mut n: u64 = 0;
    for s in ds.iter() {
        // s.repr();
        for e in s.events.iter() {
            let (dgs, errors): (Vec<_>, Vec<_>) = e.display_groups
                .into_iter()
                .map(|s| s.parse::<bov::DisplayGroup>())
                .partition(Result::is_ok);
            let dgs: Vec<_> = dgs.into_iter().map(Result::unwrap).collect();
            let errors: Vec<_> = errors.into_iter().map(Result::unwrap_err).collect();
            println!("dgs: {:?}", dgs);
            println!("Errors: {:?}", errors);

            println!("e {}", e.to_string());
            for dg in dgs {
                println!("dg {}", dg.id);
                for m in dg.markets.iter() {
                    println!("{:?}", m.to_string());
                }
            }
        }

        n += s.count_events()
    }

    println!("# games: {}", n);
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
