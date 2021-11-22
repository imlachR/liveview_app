if (window.location.pathname == "/images/new" ||
    window.location.pathname == "/videos/new" ||
    window.location.pathname == "/audios/new") {

  console.log("Uploader running...");

  let form = document.getElementById('form-uploader');
  let progressBarText = document.getElementById("file-percent");
  let conceptId = document.getElementById('concept-id');
  let formBtn = document.getElementById('form-btn');
  let whosPath = window.location.pathname.split('/')[1];

  form.addEventListener("submit", (e) => {
    e.preventDefault();

    progressBarText.style.visibility = "visible";
    new FormData(form);
  });

  form.addEventListener("formdata", (e) => {
    let data = e.formData;
    for (var value of data.values()) {
      console.log(value);
    }

    let request = new XMLHttpRequest();

    request.upload.addEventListener("progress", updateProgress);
    request.upload.addEventListener("load", transferComplete);

    request.open('POST', `/${whosPath}`);

    function updateProgress (reqEvent) {
      if (reqEvent.lengthComputable) {

        var percentComplete = reqEvent.loaded / reqEvent.total * 100;
        console.log(percentComplete);

        progressBarText.textContent = percentComplete.toFixed(2) + "%";

      } else {
        console.log("no reqEvent...");
      }
    } // updateProgress

    request.onload = function() {

      if (request.status === 200) {
        console.log("request status 200");
        window.location = `/concepts/${conceptId.value}`;
      } else if (request.status !== 200) {
        console.log("not request status" + request.status);
      }
    } // request.onload

    function transferComplete(evt) {
      console.log("Transfer Complete");
      console.log(evt);
    }

    request.send(data);

  });

} // window.location.pathname conditional statement
