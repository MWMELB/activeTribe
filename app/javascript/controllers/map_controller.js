import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Object
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkerToMap()
  }

  #addMarkerToMap() {
    // this.markerValue.forEach((marker) => {
    this.markerValue = new mapboxgl.Marker()
        .setLngLat( [ lng, lat ])
        .addTo(this.map)
    // })
  }
}
