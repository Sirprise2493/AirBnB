import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["start", "end", "nights", "total"];
  static values  = { pricePerNight: Number, currency: String };

  connect() {
    this.syncMinEnd();
    this.recalc();
  }

  syncMinEnd() {
    if (this.hasStartTarget && this.hasEndTarget && this.startTarget.value) {
      this.endTarget.min = this.startTarget.value;
    }
  }

  recalc() {
    if (!(this.hasStartTarget && this.hasEndTarget && this.hasNightsTarget && this.hasTotalTarget)) return;
    const s = this.startTarget.value;
    const e = this.endTarget.value;
    if (!s || !e) return;

    const sUTC = this.parseDateUTC(s);
    const eUTC = this.parseDateUTC(e);
    const nights = Math.max(0, Math.round((eUTC - sUTC) / 86400000)); // checkout not included

    this.nightsTarget.textContent = nights;
    const total = nights * (this.pricePerNightValue || 0);
    const currency = this.currencyValue || "EUR";
    this.totalTarget.textContent = new Intl.NumberFormat(undefined, { style: "currency", currency }).format(total);
  }

  onStartChange() {
    this.syncMinEnd();
    this.recalc();
  }

  onEndChange() {
    this.recalc();
  }

  parseDateUTC(yyyy_mm_dd) {
    const [y, m, d] = yyyy_mm_dd.split("-").map(Number);
    return Date.UTC(y, m - 1, d);
  }
}
