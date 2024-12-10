import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Object
  }

  connect() {
    MAPBOX_API_KEY = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkerToMap()
  }

  #addMarkerToMap() {

    this.markerValue = new mapboxgl.Marker()
        .setLngLat( [ lng, lat ])
        .addTo(this.map)

  }
}
