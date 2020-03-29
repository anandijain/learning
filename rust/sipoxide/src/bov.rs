extern crate serde;
// use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Root {
    pub path: Vec<Path>,
    pub events: Vec<Event>,
}


#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Path {
    pub id: String,
    pub link: Option<String>,
    pub description: String,
    #[serde(rename = "type")]
    pub type_field: String,
    pub sport_code: Option<String>,
    pub order: i128,
    pub leaf: bool,
    pub current: bool,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Event {
    pub id: String,
    pub description: String,
    #[serde(rename = "type")]
    pub type_field: String,
    pub link: String,
    pub status: String,
    pub sport: String,
    pub start_time: Option<i128>,
    pub live: bool,
    pub away_team_first: Option<bool>,
    pub deny_same_game: Option<String>,
    pub teaser_allowed: Option<bool>,
    pub competition_id: Option<String>,
    pub notes: String,
    pub num_markets: Option<u64>,
    pub last_modified: Option<i128>,
    pub competitors: Vec<Competitor>,
    // pub display_groups: Option<Vec<DisplayGroup>>,
    pub display_groups: Vec<DisplayGroup>,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Competitor {
    pub id: String,
    pub name: String,
    pub home: bool,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct DisplayGroup {
    pub id: String,
    pub description: String,
    pub default_type: Option<bool>,
    pub alternate_type: Option<bool>,
    pub markets: Vec<Market>,
    pub order: i128,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Market {
    pub id: String,
    pub description_key: Option<String>,
    pub description: String,
    pub key: String,
    pub market_type_id: Option<String>,
    pub status: String,
    pub single_only: Option<bool>,
    pub notes: String,
    pub period: Period,
    pub outcomes: Vec<Outcome>,
    pub sort_type: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Period {
    pub id: String,
    pub description: String,
    pub abbreviation: String,
    pub live: bool,
    pub main: bool,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Outcome {
    pub id: String,
    pub description: String,
    pub status: String,
    #[serde(rename = "type")]
    pub type_field: String,
    pub price: Price,
    pub competitor_id: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct Price {
    pub id: String,
    pub american: String,
    pub decimal: String,
    pub fractional: String,
    pub malay: String,
    pub indonesian: String,
    pub hongkong: String,
    pub handicap: Option<String>,
    pub handicap2: Option<String>,
}
