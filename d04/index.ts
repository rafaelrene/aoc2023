const inputFile = Bun.file("input");

const input = await inputFile.text();
const lines = input.split("\n").filter((l) => l.length !== 0);

const cards = lines.map((line) => {
  const [, allNumbers] = line.split(": ");
  const [winningNumbersAsString, myNumbersAsString] = allNumbers.split(" | ");

  const winningNumbers = winningNumbersAsString
    .split(" ")
    .filter((n) => n.length !== 0)
    .map(Number);

  const myNumbers = myNumbersAsString
    .split(" ")
    .filter((n) => n.length !== 0)
    .map(Number);

  return { winningNumbers, myNumbers };
});

const p1 = () => {
  const points = cards.map(({ winningNumbers, myNumbers }) =>
    myNumbers
      .filter((mn) => winningNumbers.includes(mn))
      .reduce((acc) => (acc === 0 ? acc + 1 : acc * 2), 0),
  );

  const res = points.reduce((acc, n) => acc + n);

  console.log(res);
};

const p2 = () => {
  console.log("Not implemented!");
};

p1();
p2();
