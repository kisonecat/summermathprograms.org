import htmx from "htmx.org";

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
          htmx.process(container);
        });
      }
    })
    .catch(error => console.error("Error fetching programs.json:", error));

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
