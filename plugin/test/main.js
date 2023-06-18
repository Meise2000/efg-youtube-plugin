function updateData(e) {
    const title = document.querySelector('#title');
    title.value = e.detail.title;
    const desc = document.querySelector('#desc');
    desc.value = e.detail.desc;
}

function copy(e) {
    const target = e.target;
    const ref = target.getAttribute('itemref');
    const input = document.querySelector('#' + ref);
    input.disabled = false;
    input.select();
    document.execCommand('copy');
    input.setSelectionRange(0, 0);
    input.disabled = true;
}

document.querySelector('body').addEventListener('youtube-values', (e) => updateData(e));
document.querySelectorAll('button').forEach(button => button.addEventListener('click', (e) => copy(e)));