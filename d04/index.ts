const inputFile = Bun.file("input");

const input = await inputFile.text();
const lines = input.split("\n").filter((l) => l.length !== 0);

const cards = lines.map((line) => {
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

  return { idCard: Number(idCard), winningNumbers, myNumbers };
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
  const p2Cards = cards.slice();

  let currentIndex = 0;

  // while (currentIndex < p2Cards.length) {
  while (currentIndex < p2Cards.length) {
    console.log("----------- START --------------");
    const currentCard = p2Cards[currentIndex];

    const winningNumbersLength = currentCard.myNumbers.filter((mn) =>
      currentCard.winningNumbers.includes(mn),
    ).length;

    for (let i = currentIndex; i < currentIndex + winningNumbersLength; i++) {
      const duplicateCard = p2Cards[i + 1];
      p2Cards.push(duplicateCard);
    }

    p2Cards.sort((a, b) => {
      if (a.idCard === b.idCard) {
        return 0;
      }

      if (a.idCard < b.idCard) {
        return -1;
      }

      return 1;
    });

    currentIndex++;
    console.log("Length: ", p2Cards.length);
    console.log("----------- END --------------");
  }

  console.log(p2Cards.length);
};

p1();
p2();
