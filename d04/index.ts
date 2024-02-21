import { Card } from "./types";

const inputFile = Bun.file("input");

const input = await inputFile.text();
const lines = input.split("\n").filter((l) => l.length !== 0);

const cards: Card[] = lines.map((line) => {
  const [prefixedIdCard, allNumbers] = line.split(": ");
  const [, idCard] = prefixedIdCard.split(" ").filter((s) => s.length !== 0);
  const [winningNumbersAsString, myNumbersAsString] = allNumbers.split(" | ");

  const winningNumbers = winningNumbersAsString
    .split(" ")
    .filter((n) => n.length !== 0)
    .map(Number);

  const myNumbers = myNumbersAsString
    .split(" ")
    .filter((n) => n.length !== 0)
    .map(Number);

  return { idCard: Number(idCard), winningNumbers, myNumbers, amount: 1 };
});

const p1 = () => {
  const points = cards.map(({ winningNumbers, myNumbers }) =>
    myNumbers
      .filter((mn) => winningNumbers.includes(mn))
      .reduce((acc) => (acc === 0 ? acc + 1 : acc * 2), 0),
  );

  const res = points.reduce((acc, n) => acc + n);

  console.log(`-------------------------------------------------`);
  console.log(`-------------- Part 1: ${res} -------------------`);
  console.log(`-------------------------------------------------`);
  console.log();
};

const p2 = () => {
  const p2Cards = cards.slice();

  let currentIndex = 0;

  while (currentIndex < p2Cards.length) {
    const currentCard = p2Cards[currentIndex];

    const winningNumbers = currentCard.myNumbers.filter((mn) =>
      currentCard.winningNumbers.includes(mn),
    );

    const winningNumbersLength = winningNumbers.length;

    let ammountLoop = 0;

    while (ammountLoop < currentCard.amount) {
      for (let i = currentIndex; i < currentIndex + winningNumbersLength; i++) {
        p2Cards[i + 1].amount += 1;
      }

      ammountLoop++;
    }

    currentIndex++;
  }

  const res = p2Cards.map((card) => card.amount).reduce((acc, n) => acc + n);

  console.log(`-------------------------------------------------`);
  console.log(`-------------- Part 2: ${res} -------------------`);
  console.log(`-------------------------------------------------`);
  console.log();
};

p1();
p2();
