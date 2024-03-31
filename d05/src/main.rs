#![allow(clippy::needless_return)]

use std::{
    collections::HashMap,
    fs::File,
    io::{self, BufRead},
    ops::Range,
};

fn read_lines(filename: &str) -> Vec<String> {
    let mut result = vec![];

    let file = File::open(filename);

    match file {
        Ok(f) => {
            for line in io::BufReader::new(f).lines() {
                result.push(line.unwrap())
            }
        }
        Err(_) => panic!("Should never happen!"),
    }

    return result;
}

#[derive(Debug, Clone)]
struct FilterRange {
    source: isize,
    destination: isize,
    length: isize,
    range: Range<isize>,
}

impl FilterRange {
    pub fn new(source: isize, destination: isize, length: isize) -> Self {
        let range = source..(source + length);

        return Self {
            source,
            destination,
            length,
            range,
        };
    }
}

fn parse_lines(lines: &[String]) -> (Vec<isize>, HashMap<&str, Vec<FilterRange>>) {
    let mut seeds = vec![];
    let mut map_names = vec![];
    let mut maps: HashMap<&str, Vec<FilterRange>> = HashMap::new();

    for line in lines.iter() {
        if line.starts_with("seeds: ") {
            seeds = line[7..line.len()]
                .split_ascii_whitespace()
                .map(|v| v.parse().unwrap())
                .collect();

            continue;
        }

        if line.ends_with(" map:") {
            map_names.push(line);

            continue;
        }

        if !line.is_empty() {
            let numbers = line
                .split_ascii_whitespace()
                .map(|v| v.parse().unwrap())
                .collect::<Vec<isize>>();

            let mut numbers = numbers.iter();

            let filter_range = FilterRange::new(
                *numbers.next().unwrap(),
                *numbers.next().unwrap(),
                *numbers.next().unwrap(),
            );

            maps.entry(map_names.last().unwrap())
                .and_modify(|value| value.push(filter_range.clone()))
                .or_insert(vec![filter_range.clone()]);
        }
    }

    return (seeds, maps);
}

fn main() {
    let lines = read_lines("input");
    let (seeds, maps) = parse_lines(&lines);

    println!("Seeds: {:?}", seeds);
    println!("Maps: {:?}", maps);
}
