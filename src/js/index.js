document.addEventListener("DOMContentLoaded", () => {
  fetch("/programs.json")
    .then(response => response.json())
    .then(data => {
      const programList = document.querySelector(".program-list");
      if (programList) {
        Object.keys(data).forEach(key => {
          const container = document.createElement("div");
          container.setAttribute("hx-get", `/partials/programs/${key}.html`);
          container.setAttribute("hx-trigger", "load");
          programList.appendChild(container);
        });
      }
    })
    .catch(error => console.error("Error fetching programs.json:", error));
});
