use core::panic;
use std::{
    fs::File,
    io::{self, BufRead},
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

    #[deny(clippy::needless_return)]
    return result;
}
fn main() {
    let lines = read_lines("input");

    print!("{:?}", lines);
}
