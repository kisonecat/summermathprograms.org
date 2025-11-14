export function setup(container, update) {
  // Insert markup (JSX-like template literal)
  container.insertAdjacentHTML('beforeend', `
<div>
  <label for="age-range-display" class="block mb-2 text-sm font-medium text-gray-700">
    Age Range: <span id="age-range-display" class="font-semibold text-gray-800">5 – 25 years old</span>
  </label>
  <div class="flex space-x-4">
    <div class="flex-1">
      <label for="age-min" class="block mb-1 text-xs font-medium text-gray-600">
        Min Age: <span id="age-min-value" class="font-semibold text-gray-800">5</span>
      </label>
      <input
        id="age-min"
        type="range"
        min="5"
        max="25"
        value="5"
        step="1"
        class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
      />
    </div>

    <div class="flex-1">
      <label for="age-max" class="block mb-1 text-xs font-medium text-gray-600">
        Max Age: <span id="age-max-value" class="font-semibold text-gray-800">25</span>
      </label>
      <input
        id="age-max"
        type="range"
        min="5"
        max="25"
        value="25"
        step="1"
        class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
      />
    </div>
  </div>
</div>
  `);

  const minSlider = document.getElementById('age-min');
  const maxSlider = document.getElementById('age-max');
  const minLabel = document.getElementById('age-min-value');
  const maxLabel = document.getElementById('age-max-value');
  const rangeDisplay = document.getElementById('age-range-display');

  function updateLabels() {
    let min = parseInt(minSlider.value, 10);
    let max = parseInt(maxSlider.value, 10);

    minLabel.textContent = min;
    maxLabel.textContent = max;
    if (min == max) {
      rangeDisplay.textContent = `${min} years old`;
    } else {
      rangeDisplay.textContent = `${min} – ${max} years old`;
    }
    
    update( program => program.eligibility.ages.some( age => age >= min && age <= max ) ||
            "does not satisfy age filter" );
  }

  // Attach listeners
  minSlider.addEventListener('input', function() {
    let min = parseInt(minSlider.value, 10);
    let max = parseInt(maxSlider.value, 10);

    // Enforce min ≤ max
    if (min > max) {
      max = min;
      maxSlider.value = max;
    }

    updateLabels();
  });

  maxSlider.addEventListener('input', function() {
    let min = parseInt(minSlider.value, 10);
    let max = parseInt(maxSlider.value, 10);

    if (max < min) {
      min = max;
      minSlider.value = min;
    }

    updateLabels();
  });
}

