document.addEventListener("DOMContentLoaded", () => {
  /* Calendar modal */
  const modal   = document.getElementById("calendar-modal");
  const openBtn = document.getElementById("open-calendar");
  const closeBtn= document.getElementById("close-calendar");
  const saveBtn = document.getElementById("save-dates");

  if (openBtn && modal) {
    openBtn.addEventListener("click", (e) => { e.preventDefault(); modal.classList.remove("hidden"); });
  }
  if (closeBtn) {
    closeBtn.addEventListener("click", () => modal.classList.add("hidden"));
  }
  if (saveBtn) {
    saveBtn.addEventListener("click", () => {
      const startStr = document.getElementById("start-date")?.value;
      const endStr   = document.getElementById("end-date")?.value;

      if (!startStr || !endStr) { modal.classList.add("hidden"); return; }

      const s = new Date(startStr);
      const e = new Date(endStr);

      const dateDisplay = document.querySelector(".js-dates") || document.querySelector(".kv .preset5.ink");
      const opts = { day: '2-digit', month: 'short', year: 'numeric' };
      if (dateDisplay) dateDisplay.textContent = `${s.toLocaleDateString('en-GB', opts)} – ${e.toLocaleDateString('en-GB', opts)}`;

      const startField = document.getElementById("start-date-field");
      const endField   = document.getElementById("end-date-field");
      if (startField) startField.value = startStr;
      if (endField)   endField.value   = endStr;

      
      const msPerDay = 24 * 60 * 60 * 1000;
      const nights = Math.max(0, Math.round((e - s) / msPerDay));
      const priceRows = document.getElementById("price-rows");
      const nightly = priceRows ? parseFloat(priceRows.dataset.nightly || "0") : 0;

      const rowNights   = document.getElementById("row-nights");
      const rowSubtotal = document.getElementById("row-subtotal");
      const rowTotal    = document.getElementById("row-total");

      if (rowNights) {
        if (nights > 0 && nightly > 0) {
          rowNights.textContent = `${nights} ${nights === 1 ? "night" : "nights"} × £${nightly.toFixed(2)}`;
        } else {
          rowNights.textContent = "Price details";
        }
      }

      const subtotal = (nights > 0 && nightly > 0) ? nights * nightly : null;
      if (rowSubtotal) rowSubtotal.textContent = subtotal ? `£${subtotal.toFixed(2)}` : "valor vazio";
      if (rowTotal) rowTotal.textContent = subtotal ? `£${subtotal.toFixed(2)}` : "valor vazio";

      modal.classList.add("hidden");
    });
  }

  /* Guests modal */
  const guestsModal = document.getElementById("guests-modal");
  const openGuests  = document.getElementById("open-guests");
  const closeGuests = document.getElementById("close-guests");
  const saveGuests  = document.getElementById("save-guests");
  const inputGuests = document.getElementById("guests-input");
  const minusBtn    = document.getElementById("minus");
  const plusBtn     = document.getElementById("plus");
  const guestsText  = document.getElementById("guests-display");
  const guestsField = document.getElementById("guests-field");
  const maxGuests   = parseInt(document.getElementById("guests-hint")?.textContent?.match(/\d+/)?.[0] || "16", 10);
  const minGuests   = 1;

  const clamp = (n, min, max) => Math.max(min, Math.min(max, n));
  const updateButtons = () => {
    const val = parseInt(inputGuests.value || 0, 10);
    minusBtn.disabled = val <= minGuests;
    plusBtn.disabled  = val >= maxGuests;
  };

  if (openGuests && guestsModal) {
    openGuests.addEventListener("click", (e) => {
      e.preventDefault();
      guestsModal.classList.remove("hidden");
      updateButtons();
      inputGuests.focus();
      inputGuests.select?.();
    });
  }
  if (closeGuests) {
    closeGuests.addEventListener("click", () => guestsModal.classList.add("hidden"));
  }

  if (minusBtn) {
    minusBtn.addEventListener("click", () => {
      inputGuests.value = clamp(parseInt(inputGuests.value || 0,10) - 1, minGuests, maxGuests);
      updateButtons();
    });
  }
  if (plusBtn) {
    plusBtn.addEventListener("click", () => {
      inputGuests.value = clamp(parseInt(inputGuests.value || 0,10) + 1, minGuests, maxGuests);
      updateButtons();
    });
  }
  if (inputGuests) {
    inputGuests.addEventListener("input", () => {
      const num = parseInt(String(inputGuests.value).replace(/[^\d]/g,''), 10);
      inputGuests.value = isNaN(num) ? minGuests : clamp(num, minGuests, maxGuests);
      updateButtons();
    });
  }

  if (saveGuests) {
    saveGuests.addEventListener("click", () => {
      const val = clamp(parseInt(inputGuests.value || 0,10), minGuests, maxGuests);
      if (guestsText) guestsText.textContent = `${val} ${val === 1 ? 'adult' : 'adults'}`;
      if (guestsField) guestsField.value = val;
      guestsModal.classList.add("hidden");
    });
  }

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      modal?.classList.add("hidden");
      guestsModal?.classList.add("hidden");
    }
  });
});
