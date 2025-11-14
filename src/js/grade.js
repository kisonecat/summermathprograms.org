export function setup(container, update) {
  // Insert markup (JSX-like template literal)
  container.insertAdjacentHTML('beforeend', `
<div>
  <label for="grade-range-display" class="block mb-2 text-sm font-medium text-gray-700">
    Grade Range: <span id="grade-range-display" class="font-semibold text-gray-800">1 – 12</span>
  </label>
  <div class="flex space-x-4">
    <div class="flex-1">
      <label for="grade-min" class="block mb-1 text-xs font-medium text-gray-600">
        Min Grade: <span id="grade-min-value" class="font-semibold text-gray-800">1</span>
      </label>
      <input
        id="grade-min"
        type="range"
        min="1"
        max="12"
        value="1"
        step="1"
        class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
      />
    </div>

    <div class="flex-1">
      <label for="grade-max" class="block mb-1 text-xs font-medium text-gray-600">
        Max Grade: <span id="grade-max-value" class="font-semibold text-gray-800">25</span>
      </label>
      <input
        id="grade-max"
        type="range"
        min="1"
        max="12"
        value="12"
        step="1"
        class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
      />
    </div>
  </div>
</div>
  `);

  const minSlider = document.getElementById('grade-min');
  const maxSlider = document.getElementById('grade-max');
  const minLabel = document.getElementById('grade-min-value');
  const maxLabel = document.getElementById('grade-max-value');
  const rangeDisplay = document.getElementById('grade-range-display');

  function updateLabels() {
    let min = parseInt(minSlider.value, 10);
    let max = parseInt(maxSlider.value, 10);

    minLabel.textContent = min;
    maxLabel.textContent = max;
    if (min == max) {
      rangeDisplay.textContent = `${min}`;
    } else {
      rangeDisplay.textContent = `${min} – ${max}`;
    }
    
    update( program => (program.eligibility && program.eligibility.grades.some( grade => grade >= min && grade <= max )) ||
            "does not satisfy grade filter" );
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

