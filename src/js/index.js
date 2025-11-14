import htmx from "htmx.org";
import Fuse from "fuse.js";

import * as filterAge from "./age";
import * as filterGrade from "./grade";

function debounce(func, timeout = 100){
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}

function applyFilters( filters, data ) {
  for( f of filters ) {
    if (f(data) !== true)
      return f(data);
  }

  return true;
}

document.addEventListener("DOMContentLoaded", () => {
  fetch("/summermathprograms.org/programs.json")
    .then(response => response.json())
    .then(data => {
      let filters = { age: () => true, grade: () => true };

      // Grab the full query string, including the leading "?"
      const queryString = window.location.search;

      // Create a URLSearchParams instance
      const params = new URLSearchParams(queryString);

      // To get a single parameter:
      const search = params.get('q');       // e.g. ?foo=bar → "bar"

      const programList = document.querySelector(".program-list");

      if (programList) {
        let results = Object.keys(data);

        if ((search !== null) && (search !== "")) {
          document.getElementById("search-box").value = search;

          const keyedData = Object.entries(data).map(([key, value]) => {
            return { key, ...value };
          });

          const allKeys = Array.from(
            new Set(
              [].concat(
                ...Object.values(data).map(item => Object.keys(item))
              )
            )
          );

          const fuse = new Fuse(keyedData, {
            keys: allKeys,
            includeScore: true,
            threshold: 0.3,
          });
          console.log( fuse.search(search) );
          results = fuse.search(search).map( v => v.item.key );
        }

        results.forEach(key => {
          const container = document.createElement("div");
          container.setAttribute("hx-get", `/summermathprograms.org/partials/programs/${key}.html`);
          container.setAttribute("hx-trigger", "load");
          container.setAttribute("data-key", key);
          programList.appendChild(container);
          htmx.process(container);
        });
      }

      function render() {
        let count = 0;

        Array.from(programList.children).forEach(child => {
          const key = child.dataset.key;
          const isAccepted = applyFilters( Object.values(filters), data[key] );
          if (isAccepted === true) count = count + 1;
          child.classList.toggle('hidden', isAccepted !== true);

          if (count != 1)
            document.getElementById('match-count').textContent = `${count} matching programs`;
          else
            document.getElementById('match-count').textContent = `1 matching program`;
        });
      }

      render();
      
      const filterElement = document.querySelector("#filters");
      if (filterElement) {
        filterAge.setup( filterElement, (f) => {
          filters.age = f;
          requestAnimationFrame(render);
        });
        filterElement.insertAdjacentHTML('beforeend', `<hr/>`);
        filterGrade.setup( filterElement, (f) => {
          filters.grade = f;
          requestAnimationFrame(render);
        });
      }
    })
    .catch(error => console.error("Error fetching programs.json:", error));
});

document.addEventListener("DOMContentLoaded", () => {
  // Slider code for hero section on the landing page
  const slides = document.querySelectorAll('.hero-slide');
  const indicators = document.querySelectorAll('#slider-indicators button');

  let currentSlide = 0;
  const totalSlides = slides.length;

  if (totalSlides > 0) {
    // Initialize first slide indicator
    slides[currentSlide].classList.remove('opacity-0');
    slides[currentSlide].classList.add('opacity-100');
    indicators[currentSlide].classList.remove('opacity-50');
    indicators[currentSlide].classList.add('opacity-75');

    setInterval(() => {
      // Fade out current slide
      slides[currentSlide].classList.remove('opacity-100');
      slides[currentSlide].classList.add('opacity-0');
      indicators[currentSlide].classList.remove('opacity-75');
      indicators[currentSlide].classList.add('opacity-50');

      // Move to next slide
      currentSlide = (currentSlide + 1) % totalSlides;

      // Fade in next slide
      slides[currentSlide].classList.remove('opacity-0');
      slides[currentSlide].classList.add('opacity-100');
      indicators[currentSlide].classList.remove('opacity-50');
      indicators[currentSlide].classList.add('opacity-75');
    }, 5000);
  }
});
