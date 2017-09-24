function injectReddit() {
    var comments = document.getElementsByClassName('entry');
    for (var i = 1; i < comments.length; i++) {
        var comment = comments[i];
        var buttons = comment.getElementsByClassName('buttons')[0];

        if (buttons) {
            if (buttons.querySelectorAll('[data-event-action=permalink]').length == 1) {
                var link = document.createElement('a');
                link.innerText = 'Share Like Pro';
                link.href = '#';
                link.onclick = function (event) {
                    var url = this.parentNode.parentNode.firstChild.firstChild.href;
                    var apiUrl = 'https://sharelike.pro/reddit/posts' + url.replace('https://www.reddit.com/r', '');
                    window.open(apiUrl, "", "width=500,height=250");
                    event.preventDefault();
                };
                var li = document.createElement('li');
                li.append(link);

                buttons.append(li);
            }
        }
    }
}

function injectHN() {
    var comments = document.getElementsByClassName('comtr');
    for (var i = 0; i < comments.length; i++) {
        var comment = comments[i];
        var container = comment.getElementsByClassName('reply')[0].getElementsByTagName('font')[0];

        var link = document.createElement('a');
        link.innerText = 'Share Like Pro';
        link.href = '#';
        link.onclick = function (event) {
            var node = this;
            for (var i = 0; i < 11; i ++) {
                node = node.parentNode;
            }
            var apiUrl = 'https://sharelike.pro/hn/posts/' + node.id;
            window.open(apiUrl, "", "width=500,height=250");
            event.preventDefault();
        };

        container.append(link);
    }
}

switch (window.location.hostname) {
    case 'www.reddit.com':
        injectReddit();
        break;
    case 'news.ycombinator.com':
        injectHN();
        break;

}