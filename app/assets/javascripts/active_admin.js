//= require active_admin/base

document.addEventListener('DOMContentLoaded', function() {
    const deleteLinks = document.querySelectorAll('a[data-method="delete"]');
    deleteLinks.forEach(function(link) {
      link.setAttribute('data-turbo', 'false');
    });

    const editors = document.querySelectorAll('.quill-editor');
    if(editors.length > 0) {
      editors.forEach(function(editor) {
        const container = document.createElement('div');
        container.className = 'quill-editor-container';
        container.style.height = '300px';
        container.style.marginBottom = '15px';
        editor.parentNode.insertBefore(container, editor);
        
        editor.style.display = 'none';
        
        const quill = new Quill(container, {
          theme: 'snow',
          modules: {
            toolbar: [
              ['bold', 'italic', 'underline', 'strike'],
              ['blockquote', 'code-block'],
              [{ 'header': 1 }, { 'header': 2 }],
              [{ 'list': 'ordered' }, { 'list': 'bullet' }],
              [{ 'script': 'sub' }, { 'script': 'super' }],
              [{ 'indent': '-1' }, { 'indent': '+1' }],
              [{ 'size': ['small', false, 'large', 'huge'] }],
              [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
              [{ 'color': [] }, { 'background': [] }],
              [{ 'font': [] }],
              [{ 'align': [] }],
              ['clean'],
              ['link', 'image']
            ]
          }
        });
        
        quill.root.innerHTML = editor.value;

        editor.form.addEventListener('submit', function() {
          editor.value = quill.root.innerHTML;
        });
      });
    }
  });