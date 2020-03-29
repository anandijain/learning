#[macro_use]
extern crate serde_derive;
extern crate serde;
// extern crate reqwest;
// use reqwest::Error;
use std::fmt;
use std::fmt::Debug;
use std::fs;

mod bov;

// impl bov::Outcome {
//     fn repr(&self) {
//         println!("oc {} {}", self.description, self.price.decimal);
//         // self.price.repr()
//     }
// }
// impl bov::Market {
//     fn repr(&self) {
//         println!("{}", self.description);
//         for o in self.outcomes.iter() {
//             o.repr();
//         }
//     }
// }
// impl bov::DisplayGroup {
//     fn repr(&self) {
//         for m in self.markets.iter() {
//             m.repr();
//         }
//     }
// }

impl bov::Root {
    // fn repr(&self) {
    //     for e in self.events.iter() {
    //         e.repr();
    //     }
    // }

    fn count_events(&self) -> u64 {
        let mut n: u64 = 0;
        for e in self.events.iter() {
            n += 1;
        }
        return n;
    }
}

// impl ToString for bov::Competitor {
//     fn to_string(&self) -> String {
//         return format!("Competitor {} {} {}", self.id, self.name, self.home);
//     }
// }
// impl ToString for bov::Outcome {
//     fn to_string(&self) -> String {
//         return format!("oc {} {}", self.description, self.price.decimal);
//     }
// }
// impl ToString for bov::Market {
//     fn to_string(&self) -> String {
//         return format!("mkt {} {}", self.id, self.description);
//     }
// }
impl ToString for bov::Price {
    fn to_string(&self) -> String {
        return format!("mkt {} {} {}", self.id, self.american, self.decimal);
    }
}

// impl ToString for bov::DisplayGroup {
//     fn to_string(&self) -> String {
//         return format!("Dg {} {}", self.id, self.description);
//     }
// }


// impl ToString for bov::Event {
//     fn to_string(&self) -> String {
//         // return format!("ev {} {} {} {:?}", self.id, self.sport, self.description, self.display_groups);
//         let res: String = match &self.display_groups {
//             Some(dgs) => format!("{:?}", dgs),
//             None => format!("no dgs for {}", self.id),
//         };
//         return res
//     }
// }

// impl bov::Event {
//     fn repr(&self) {
//         println!("{} {} {}", self.id, self.description, self.sport);
//         for c in self.competitors.iter() {
//             println!("{}", c.to_string());
//         }
//         match &self.display_groups {
//             Some(dgs) => println!("{:?}", *dgs),
//             None => println!("{}", self.id),
//         };
//     }
// }
// impl fmt::Display for bov::Root {
//     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
//         write!(f, "{}", self.events)        
//     }
// }

impl fmt::Display for bov::Event {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:#?}", self.display_groups)        
    }
}

impl fmt::Display for bov::DisplayGroup {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "DG_START{} {} {} {:#?}", self.id, self.description, self.order, self.markets.iter())
    }
}

impl fmt::Display for bov::Market {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:#?}", self.outcomes) 
    }
}
impl fmt::Display for bov::Outcome {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.price.to_string())
    }
}

// fn basic_event_repr(e: &bov::Event) -> String {
//     match e.display_groups {
//         Some(n)
//     }


fn parse() {
    let contents = fs::read_to_string("./data/root.json")
        .expect("Something went wrong reading the file")
        .to_string();

    let ds: Vec<bov::Root> = serde_json::from_str(&contents).unwrap();
    // let ds: Vec<bov::DisplayGroup> = serde_json::from_str(&contents).unwrap();
    // let ds: bov::Event = serde_json::from_str(&contents).unwrap();
    // println!("{}", ds.description);
    // println!("{:#?}", ds.display_groups);
    // println!("{}", ds[0].id);
    let mut n: u64 = 0;
    for s in ds.iter() {
        // s is a Root
        println!("{}", s.to_string());
        for e in s.events.iter() {
            // match e.display_groups {
            //     Some(dgs) => {
            //         println!("{:?}", dgs.iter().to_string().format(", "));
            //     },
            //     _ => {
            //         println!("no dgs");
            //     },
            // };
            // if let Some(dgs) = &e.display_groups {
            //     for dg in dgs.iter() {
            //         for m in dg.markets.iter() {
            //             for oc in m.outcomes.iter() {
            //                 println!("{} {} {} {}", e.id, e.description, dg.description, oc.price.decimal);
            //             }
            //         }
            //         println!("{}", dg);
            //     }
            // } else {
            //     println!("FUCK {} {} {}", e.id, e.description, e.sport);
            // }
            for dg in e.display_groups.iter() {
                for m in dg.markets.iter() {
                    for oc in m.outcomes.iter() {
                        println!("{} {} {} {}", e.id, e.description, dg.description, oc.price.decimal);
                    }
                }
                println!("{}", dg);
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
