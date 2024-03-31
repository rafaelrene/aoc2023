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
    start: isize,
    range: Range<isize>,
}

impl FilterRange {
    pub fn new(start: isize, length: isize) -> Self {
        let range = start..(start + length);

        return Self { start, range };
    }

    pub fn contains(&self, source: &isize) -> bool {
        return self.range.contains(source);
    }
}

#[derive(Debug, Clone)]
struct Map {
    source: FilterRange,
    destination: FilterRange,
}

impl Map {
    pub fn get_destination(&self, source_value: isize) -> isize {
        if self.source.contains(&source_value) {
            let diff = source_value - self.source.start;

            return self.destination.start + diff;
        }

        return source_value;
    }
}

fn parse_lines(lines: &[String]) -> (Vec<isize>, Vec<Vec<Map>>) {
    let mut seeds = vec![];
    let mut map_names = vec![];
    let mut filter_map_hash: HashMap<&str, Vec<Map>> = HashMap::new();

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

            let destination = *numbers.next().unwrap();
            let source = *numbers.next().unwrap();
            let length = *numbers.next().unwrap();

            let source_filter_range = FilterRange::new(source, length);
            let destination_filter_range = FilterRange::new(destination, length);

            let filter_map = Map {
                source: source_filter_range,
                destination: destination_filter_range,
            };

            filter_map_hash
                .entry(map_names.last().unwrap())
                .and_modify(|v| v.push(filter_map.clone()))
                .or_insert(vec![filter_map.clone()]);
        }
    }

    let mut ordered_filter_maps: Vec<Vec<Map>> = vec![];

    for map_name in map_names {
        let a = filter_map_hash.get(map_name.as_str()).unwrap().to_vec();

        ordered_filter_maps.push(a);
    }

    return (seeds, ordered_filter_maps);
}

fn part_one(lines: &[String]) {
    let (seeds, maps) = parse_lines(lines);

    let location = seeds
        .iter()
        .map(|seed| {
            maps.iter().fold(*seed, |acc, vec_map| {
                vec_map
                    .iter()
                    .find(|&m| m.source.contains(&acc))
                    .map(|m| m.get_destination(acc))
                    .unwrap_or(acc)
            })
        })
        .min()
        .unwrap();

    println!("-------------------- PART ONE -------------------------");
    println!("Lowest location: {:?}", location);
    println!("------------------ PART ONE (END) ---------------------");
}

fn part_two(_lines: &[String]) {
    todo!();
}

fn main() {
    let lines = read_lines("input");

    part_one(&lines);
    part_two(&lines);
}
