import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { markers: Array }

  async connect() {
    const { Map } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    const map = new Map(this.element, {
      center: { lat: 41.8781, lng: -87.6298 }, // Default center
      zoom: 12,
      mapId: "DEMO_MAP_ID",
    });

    const bounds = new google.maps.LatLngBounds();

    this.markersValue.forEach((markerData) => {
      if (markerData.lat && markerData.lng) {
        const position = { lat: parseFloat(markerData.lat), lng: parseFloat(markerData.lng) };
        
        new AdvancedMarkerElement({
          map: map,
          position: position,
          title: markerData.title,
        });

        bounds.extend(position);
      }
    });

    if (!bounds.isEmpty()) { map.fitBounds(bounds); }
  }
}
