const Locale = {
  mounted() {
    console.log("Mounted", this.el);

    var localeIndicator = this.el;
    var locale = navigator.language;
    console.log(locale);
    var minLocale = locale.substring(0,2);

    if (document.getElementById('locale-link')) {
      var localeLink = document.getElementById('locale-link');

      localeLink.onclick = function() {
        modal.style.display = "block";
      }
    }

    if (document.getElementById('locale-link-desktop')) {
      var localeLinkDesktop = document.getElementById('locale-link-desktop');

      localeLinkDesktop.onclick = function() {
        modal.style.display = "block";
      }
    }

    var modal = document.getElementById('modal-locale');
    var span = document.getElementsByClassName('modal-content__close')[0];

    // if (this.el.dataset.hasLocale === "nil") {
    //   modal.style.display = "block";
    // }

    span.onclick = function() {
      modal.style.display = "none";
    }

    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }
  }
}

export default Locale
