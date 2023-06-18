class YoutubeDialog extends HTMLElement {
    #shadow;

    constructor() {
        super();
        this.#shadow = this.attachShadow({ mode: 'closed' });;
        this.#shadow.addEventListener('click', (e) => this.#handleClick(e));
        this.#shadow.addEventListener('change', (e) => this.#handleChange(e));
    }

    connectedCallback() {
        this.#shadow.innerHTML = `
        <link rel="stylesheet" href="../src/form.css">
        <form>
            <label for="title">Titel</label>
            <label for="title_ir" dir="rtl" lang="ir">عنوان</label>
            <input type="text" id="title" placeholder="Überschrift der Predigt">
            <div>
                <input type="text" dir="rtl" id="title_ir" lang="ir">
                <a href="#title">Titel übersetzen</a>
            </div>

            <label for="name">Sprecher</label>
            <label for="type">Art (optional)</label>
            <input type="text" list="speakers" id="name" placeholder="z.B. Rebecca B. oder Stephan H.">
            <datalist id="speakers">
                <option value="Rebecca B.">
                <option value="Stephan H.">
            </datalist>
            <input type="text" id="type" placeholder="z.B. Taufgottesdienst etc.">

            <label for="source">Bibeltext</label>
            <label for="source_ir" dir="rtl" lang="ir">متن کتاب مقدس</label>
            <input type="text" id="source" placeholder="z.B. Joh. 3,16">
            <div>
                <input type="text" id="source_ir" dir="rtl" lang="ir">
                <a href="#source">Bibeltext übersetzen</a>
            </div>

            <label for="desc">Beschreibung</label>
            <label for="desc_ir" dir="rtl" lang="ir">شرح</label>
            <textarea id="desc"></textarea>
            <div>
                <textarea id="desc_ir" lang="ir" dir="rtl"></textarea>
                <a href="#desc">Beschreibung übersetzen</a>
            </div>
        </form>`;
    }
    #handleClick(e) {
        const target = e.target;
        if (target.tagName.toLowerCase() === 'a') {
            e.preventDefault();
            e.stopPropagation();
            const ref = target.href.split('#')[1];
            const input = this.#shadow.querySelector('#' + ref);
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
        const input = this.#shadow.querySelector('#' + id);
        return input.value;
    }

    #translateInNewTab(input) {
        const url = 'https://translate.google.de/?sl=de&tl=fa&text=' + decodeURI(input.value);
        window.open(url, '_blank').focus();
    }

    #handleEmptyInputField(input) {
        const label = this.#shadow.querySelector('label[for="' + input.id + '"]').innerHTML;
        input.focus();
        window.alert(`Bitte zunächst das Feld "${label}" ausfüllen!`);
}

}

customElements.define("efg-youtube-dialog", YoutubeDialog);
