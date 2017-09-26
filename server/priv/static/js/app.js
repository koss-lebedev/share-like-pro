// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.3.0/priv/static/phoenix_html.js


var elements = document.querySelectorAll('[data-submit^=parent]');
for (var i=0; i<elements.length; ++i) {
    elements[i].addEventListener('click', function(event){
        var message = this.getAttribute("data-confirm");
        if(message === null || confirm(message)){
            this.parentNode.submit();
        }
        event.preventDefault();
        return false
    }, false)
}