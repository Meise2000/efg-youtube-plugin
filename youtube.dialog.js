class YoutubeDialog extends HTMLElement {
    constructor() {
        super();
        this.shadowRoot.addEventListener('click', (e) => this.#handleClick(e));
        this.shadowRoot.addEventListener('change', (e) => this.#handleChange(e));
    }

    #handleClick(e) {
        const target = e.target;
        if (target.tagName.toLowerCase() === 'a') {
            e.preventDefault();
            e.stopPropagation();
            const ref = target.href.split('#')[1];
            const input = this.shadowRoot.querySelector('#' + ref);
            if (input.value) {
                this.#translateInNewTab(input);
            } else {
                this.#handleEmptyInputField(input);
            }
        }
    }

    #handleChange(e) {
        const title = this.#getValueById('title');
        const title_ir = this.#getValueById('title_ir');
        const name = this.#getValueById('name');
        const type = this.#getValueById('type');
        const source = this.#getValueById('source');
        const source_ir = this.#getValueById('source_ir');
        const desc = this.#getValueById('desc');
        const desc_ir = this.#getValueById('desc_ir');

        let youtubeTitle = [title, name, source].join(' | ');
        if (type) {
            youtubeTitle += ' (' + type + ')';
        }
        const youtubeDesc = '🇩🇪\n' + desc + '\n🇮🇷\n' + desc_ir + '\n🇮🇷\n' + title_ir + ' | ' + source_ir;
        const event = new CustomEvent("youtube-values", { detail: {title: youtubeTitle, desc: youtubeDesc}, bubbles: true });
        this.dispatchEvent(event);
    }

    #getValueById(id) {
        const input = this.shadowRoot.querySelector('#' + id);
        return input.value;
    }

    #translateInNewTab(input) {
        const url = 'https://translate.google.de/?sl=de&tl=fa&text=' + decodeURI(input.value);
        window.open(url, '_blank').focus();
    }

    #handleEmptyInputField(input) {
        const label = this.shadowRoot.querySelector('label[for="' + input.id + '"]').innerHTML;
        input.focus();
        window.alert(`Bitte zunächst das Feld "${label}" ausfüllen!`);
}

}

customElements.define("efg-youtube-dialog", YoutubeDialog);

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