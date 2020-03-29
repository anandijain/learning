#[macro_use]
extern crate serde_derive;
extern crate csv;
extern crate serde;
use std::error::Error;

mod bov;

fn parse_and_write(json_data: String) -> Result<(), Box<dyn Error>> {
    let write_fn = "./data/root.csv";

    let mut wtr = csv::Writer::from_path(write_fn)?;

    wtr.write_record(&[
        "id",
        "sport",
        "event_desc",
        "dg_desc",
        "mkt_desc",
        "oc_desc",
        "price",
        "hc",
    ])?;
    // TODO use in test
    // let json_data = fs::read_to_string("./data/root.json")
    //     .expect("Something went wrong reading the file")
    //     .to_string();

    let ds: Vec<bov::Root> = serde_json::from_str(&json_data).unwrap();

    for s in ds.iter() {
        // s is a Root
        for e in s.events.iter() {
            for dg in e.display_groups.iter() {
                for m in dg.markets.iter() {
                    for oc in m.outcomes.iter() {
                        if let Some(hc) = &oc.price.handicap {
                            let rec = &[
                                &e.id,
                                &e.sport,
                                &e.description,
                                &dg.description,
                                &m.description,
                                &oc.description,
                                &oc.price.decimal,
                                &hc.to_string(),
                            ];
                            wtr.write_record(rec)?;
                            println!("{:#?}", rec);
                        } else {
                            let rec = &[
                                &e.id,
                                &e.sport,
                                &e.description,
                                &dg.description,
                                &m.description,
                                &oc.description,
                                &oc.price.decimal,
                                &"".to_string(),
                            ];
                            wtr.write_record(rec)?;
                            println!("{:#?}", rec);
                        }
                    }
                }
            }
        }
    }
    wtr.flush()?;
    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), reqwest::Error> {
    let res = reqwest::get("https://www.bovada.lv/services/sports/event/v2/events/A/description/")
        .await?;

    println!("Status: {}", res.status());

    let body = res.text().await?;

    parse_and_write(body.to_string());

    Ok(())
}
