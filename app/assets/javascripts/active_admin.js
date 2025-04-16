//= require active_admin/base

document.addEventListener('DOMContentLoaded', function() {
  const deleteLinks = document.querySelectorAll('.delete-link, a[data-method="delete"]');
  deleteLinks.forEach(function(link) {
    link.setAttribute('data-turbo', 'false');
    
    link.addEventListener('click', function(e) {
      e.preventDefault();
      
      if (confirm('Are you sure you want to delete this item?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = this.href;
        form.style.display = 'none';
        
        const methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = '_method';
        methodInput.value = 'delete';
        form.appendChild(methodInput);
        
        const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'authenticity_token';
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
        
        document.body.appendChild(form);
        form.submit();
      }
    });
  });
  
  const editors = document.querySelectorAll('.quill-editor');
  if(editors.length > 0) {
    editors.forEach(function(editor) {
      const container = document.createElement('div');
      container.className = 'quill-editor-container';
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
            [{ 'indent': '-1' }, { 'indent': '+1' }],
            [{ 'size': ['small', false, 'large', 'huge'] }],
            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
            [{ 'color': [] }, { 'background': [] }],
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
  
  const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  if (tooltips.length > 0 && typeof bootstrap !== 'undefined') {
    tooltips.forEach(tooltip => {
      new bootstrap.Tooltip(tooltip);
    });
  }
});