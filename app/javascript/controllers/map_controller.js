import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = { apiKey: String, markers: Array }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = marker.info_window_html
        ? new mapboxgl.Popup().setHTML(marker.info_window_html)
        : undefined

      const m = new mapboxgl.Marker({ color: "#d9480f" }).setLngLat([marker.lng, marker.lat])
      if (popup) m.setPopup(popup)
      m.addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(m => bounds.extend([m.lng, m.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 120 })
  }
}
