function initTinyMCE() {
  tinyMCE.remove();

  tinyMCE.init({
    selector: '.wysiwyg',
    entity_encoding: 'raw',
    plugins: 'image media link lists code',
    toolbar: 'styleselect | bold italic | undo redo | image media link | numlist bullist | code',
    media_dimensions: false,
    media_alt_source: false,
    media_poster: false,
    setup: function(editor) {
      editor.on('ExecCommand', (event) => {
        const command = event.command
        if (command === 'mceMedia') {
          const tabElems = document.querySelectorAll('div[role="tablist"] .tox-tab')
          tabElems.forEach(tabElem => {
            if (tabElem.innerText === 'Embed') {
              tabElem.style.display = 'none'
            }
          })
        }
      })
    },
    image_class_list: [{title: 'Responsive', value: 'img-responsive'}],
    /* enable title field in the Image dialog*/
    image_title: true,
    /* enable automatic uploads of images represented by blob or data URIs*/
    automatic_uploads: true,
    /*
      URL of our upload handler (for more details check: https://www.tiny.cloud/docs/configure/file-image-upload/#images_upload_url)
      images_upload_url: 'postAcceptor.php',
      here we add custom filepicker only to Image dialog
    */
    content_style: 'body {font-size: 16pt text-align: justify}',
    fontsize_formats: '16pt 18pt 24pt 30pt 36pt 48pt 60pt 72pt 96pt',
    paste_retain_style_properties: 'font-size text-align',
    file_picker_types: 'image',
    images_upload_url: '/admin/tiny_mce/upload',
    default_link_target:'_blank',
    /* and here's our custom image picker*/
    file_picker_callback: function (cb, value, meta) {
      var input = document.createElement('input')
      input.setAttribute('type', 'file')
      input.setAttribute('accept', 'image/*')
      /*
        Note: In modern browsers input[type="file"] is functional without
        even adding it to the DOM, but that might not be the case in some older
        or quirky browsers like IE, so you might want to add it to the DOM
        just in case, and visually hide it. And do not forget do remove it
        once you do not need it anymore.
      */
      input.onchange = function () {
        var file = this.files[0]
        var reader = new FileReader()
        // compress images
        new Compressor(file, {
          quality: 0.6,

          // The compression process is asynchronous,
          // which means you have to access the `result` in the `success` hook function.
          success(file_compressed) {
            reader.onload = function () {
              /*
                Note: Now we need to register the blob in TinyMCEs image blob
                registry. In the next release this part hopefully won't be
                necessary, as we are looking to handle it internally.
              */
              var id = 'blobid' + (new Date()).getTime()
              var blobCache =  tinymce.activeEditor.editorUpload.blobCache
              var base64 = reader.result.split(',')[1]
              var blobInfo = blobCache.create(id, file_compressed, base64)
              blobCache.add(blobInfo)
              /* call the callback and populate the Title field with the file name */
              cb(blobInfo.blobUri(), { title: file_compressed.name })
            }
            reader.readAsDataURL(file_compressed)
          },
          error(err) {
            console.log(err.message)
          },
        })
      }
      input.click()
    }
  })
}

initTinyMCE();
