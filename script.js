const cats = ["Sir Fluffington III", "Baron von Whiskers", "Miss Marple the Tabby", "fourth cat in the array"];

function featuredCat() {
  const today = new Date().getDate();
  return cats[today % cats.length];
}

document.addEventListener("DOMContentLoaded", () => {
  const strong = document.querySelector("strong");
  if (strong) strong.textContent = featuredCat();
});