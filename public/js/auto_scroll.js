document.addEventListener('DOMContentLoaded', function() {
  const startStopBtn = document.getElementById('start-stop-scroll');
  const speedSlider = document.getElementById('speed-slider');
  const speedDisplay = document.getElementById('speed-display');

  let scrollInterval = null;
  let isScrolling = false;

  const toggleScroll = () => {
    if (isScrolling) {
      clearInterval(scrollInterval);
      isScrolling = false;
      startStopBtn.textContent = 'Start Auto-Scroll';
      startStopBtn.classList.remove('scrolling');
    } else {
      isScrolling = true;
      startStopBtn.textContent = 'Stop Auto-Scroll';
      startStopBtn.classList.add('scrolling');

      const scroll = () => {
        const speed = parseInt(speedSlider.value, 10);
        const intervalTime = 150 / speed;

        if (scrollInterval) {
          clearInterval(scrollInterval);
        }

        scrollInterval = setInterval(() => {
          if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
            toggleScroll();
          } else {
            window.scrollBy(0, 1);
          }
        }, intervalTime);
      };

      scroll();
    }
  };

  startStopBtn.addEventListener('click', toggleScroll);
  speedSlider.addEventListener('input', () => {
    const speed = speedSlider.value;
    speedDisplay.textContent = speed;
    if (isScrolling) {
      toggleScroll();
      toggleScroll();
    }
  });
});
