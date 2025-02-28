import { u } from 'umbrellajs';

u(document).on('submit', 'form', function(event) {
  const $form = u(this);
  const $button = $form.find('button.btn-spinner');
  if ($button.length === 0) {
    return;
  }

  const width = $button.size().width;
  $button.attr('disabled', true);
  $button.attr('style', `width: ${width}px`);
  $button.html(`
    <div class="spinner-border spinner-border-sm" role="status">
      <span class="sr-only">Loading...</span>
    </div>
  `);
});
