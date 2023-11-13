// Prevent uploading of big images.
document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (event) {
    const BYTE2MB = 1024 * 1024;
    I18n.locale = document.querySelector("body").getAttribute("data-locale");
    let image_upload = document.querySelector("#micropost_image");
    const size_in_megabytes = image_upload?.files[0]?.size / BYTE2MB;
    if (size_in_megabytes > Settings.validation.image_size_max) {
      alert(I18n.t("errors.huge_image"));
      image_upload.value = "";
    }
  });
});
