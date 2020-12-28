export default class Poll {
    constructor(target, title = '', options = []) {
        this.id = this.generateId()
        this.title = title;
        this.target = $(`${target}`)
        this.url = this.target.data('url')
        this.auth_token = this.target.data('token')
        this.options = {};
        this.action = 'initial'
        this.controls = {
            createBtn: {label: 'Erstellen', style: 'btn-primary', display: 'none', action: ['initial']},
            saveBtn: {label: 'Speichern', style: 'btn-success', display: 'none', action: ['create']},
            addBtn: {label: 'Hinzufügen', style: 'btn-info', display: 'none', action: ['create']},
            resetBtn: {label: 'Verwerfen', style: 'btn-danger', display: 'none', action: ['create', 'show']},
            editBtn: {label: 'Bearbeiten', style: 'btn-primary', display: 'none', action: ['show']}
        };
        options.forEach((option, index)=> {
            this.options[`option_${index + 1}`] = option;
        })
        this.initialize()
    }

    initialize() {
        this.alertWindow = $(`<div id="alert-box-${this.id}" class="alert alert-danger" role="alert" style="display:none;"></div>`)
        this.pollCreateWindow = $(`<div id="poll-create-${this.id}"></div>`)
        this.pollShowWindow = $(`<div id="poll-show-${this.id}"></div>`)
        this.target.append(this.pollCreateWindow)
        this.target.append(this.pollShowWindow)
        this.inputs = $(`<div id="inputs-${this.id}"></div>`)
        this.pollCreateWindow.append(this.alertWindow)
        this.renderTitleInput();
        this.pollCreateWindow.append(this.inputs)
        this.renderControls();
        this.toggleButtons();
    }

    assignAjaxEvents() {
        let self = this
        this.form.on('ajax:success', (event)=> {
            console.log(event)
            let data = event.detail[0]
            let response = JSON.parse(data)

            self.addAlert(response.message)
        })
        this.form.on('ajax:before', ()=> {
            self.addAlert('Umfrage abgeschickt!')
            // Disable button
        })
    }

    reset() {
        this.target.empty();
        new Poll(`#${this.target.attr('id')}`)
    }

    setAction(string) {
        this.action = string
        this.toggleButtons();
    }

    setTitle() {
        this.title = this.titleInput.val();
        if(this.title === '') {
            return false
        }
        this.titleContainer.remove();
        this.target.prepend(`<h3>${this.title}</h3`)
    }

    generateId() {
        return '_' + Math.random().toString(36).substr(2, 9);
    }

    renderControls() {
        let controls = Object.entries(this.controls)
        let wrapper = $('<div id="actions"></div>')
        let self = this
        controls.forEach((keyValue)=> {
            let btn = $(this.buildButton(keyValue[0], keyValue[1]))
            this[keyValue[0]] = btn;
            wrapper.append(btn)
            eval(`self.${keyValue[0]}Event(btn)`)
        })
        this.target.append(wrapper);
    }

    toggleButtons() {
        let controls = Object.entries(this.controls)
        controls.forEach((keyValue) => {
            if(keyValue[1].action.includes(this.action)) {
                this[keyValue[0]].show();
            } else {
                this[keyValue[0]].hide();
            }
        })
    }

    renderTitleInput() {
        let input = `<div class="input-group flex-nowrap mb-2" id="poll-title-${this.id}">
  <span class="input-group-text" id="addon-wrapping">Title</span>
  <input aria-describedby="addon-wrapping" aria-label="Title" class="form-control" id="poll-title-input-${this.id}" placeholder="Enter a Poll-title" type="text"></input>
</div>
`
        this.pollCreateWindow.append(input)
        this.titleInput = $(`#poll-title-input-${this.id}`)
        this.titleContainer = $(`#poll-title-${this.id}`)
    }

    buildButton(key, format) {
        return `<button id="${key}-${this.id}" class="ml-2 btn ${format.style}" style="display:${format.display};">${format.label}</button>`
    }

    optionsCount() {
        return Object.keys(this.options).length
    }

    addOption(option) {
        let id = this.generateId()
        this.options[`option_${id}`] = option
        return id
    }

    setPlaceholders() {
        let keys = Object.keys(this.options)
        keys.forEach(function (key, index) {
            $(`#${key}`).attr('placeholder', `Option ${index + 1}`)
        })
    }

    removeOption(index) {
        let removedEntry = this.options[`option_${index}`]
        delete this.options[`option_${index}`]
        $(`#option_${index}_field_${this.id}`).remove();
        this.setPlaceholders();
        return removedEntry;
    }

    saveInputs() {
        let keys = Object.keys(this.options)
        keys.forEach((key)=> {
            this.options[key] = $(`#${key}`).val()
        })
        let values = Object.values(this.options)
        if(values.includes('')) {
            this.addAlert('Fülle alle Felder aus!')
        } else {
            this.show();
        }
    }

    assignDestroyEvents() {
        let self = this;
        $(`.destroy-button-${self.id}`).on('click', function(){
            if(self.optionsCount() > 2) {
                let id = $(this).data('id')
                self.removeOption(id)
            } else {
                self.addAlert('Eine Umfrage muss mindestens zwei Einträge haben!')
            }
        })
    }

    createBtnEvent(el) {
        let self = this
        el.on('click', function() {
            if(self.setTitle() != false) {
                self.renderCreate();
                $(this).hide();
            } else {
                self.addAlert('Title is missing!')
            }
        })
    }

    saveBtnEvent(el) {
        let self = this
        el.on('click', function(){
            self.saveInputs();
        })
    }

    editBtnEvent(el) {
        let self = this
        el.on('click', function(){
            self.renderEdit()
        })
    }

    sendBtnEvent(el) {
        let self = this
        el.on('click', function(){
            self.form.submit();
        })
    }


    addBtnEvent(el) {
        let self = this
        el.on('click', function(){
            self.addOptionInput();
        })
    }
    resetBtnEvent(el) {
        let self = this
        el.on('click', function(){
            self.reset();
        })
    }

    renderOptionInput(index) {
        let id = this.addOption('')
        let inputWrapper = this.inputWrapper(id)
        inputWrapper.prepend(this.inputAddon(id))
        inputWrapper.prepend(this.textInput(id, index))
        return inputWrapper
    }

    pollForm(elements = []) {
        let authInput = `<input type="hidden" name="authenticity_token" value="${this.auth_token}">`
        let titleInput = `<input type="hidden" name="poll[title]" value="${this.title}">`
        let form = $(`<form action="${this.url}" enctype="multipart/form-data" accept-charset="UTF-8" method="post" data-remote="true"></form>`)
        form.append(authInput)
        form.append(titleInput)
        elements.forEach((el)=> {
            form.append(el)
        })
        form.append(`<input type="submit" class="btn btn-primary" value="Starten">`)
        return form
    }

    inputWrapper(id) {
        return $(`<div class="input-group mb-3" id="option_${id}_field_${this.id}"></div>`)
    }

    textInput(id, index, readonly = false, option = undefined) {
        let input = $(`<input type="text" class="form-control" placeholder="Option ${index + 1}" id="option_${id}" name="poll[option_${index}]" aria-label="Option ${index + 1}" aria-describedby="basic-addon1" ${readonly ? 'readonly': ''}>`)
        if(option) { input.val(option) }
        return input
    }

    inputAddon(id, index = undefined, addOn= 'destroy') {
        let addOnContent = addOn === 'index' ? index : '<i class="fa fa-minus-square""></i>'
        return `<span class="input-group-text destroy-button-${this.id}" id="basic-addon1" data-id="${id}">${addOnContent}</span>`
    }
    buildInput(id, index, option) {
        let wrapper = this.inputWrapper(id)
        wrapper.append(this.inputAddon(id, index, 'index'))
        wrapper.append(this.textInput(id, index, true, option))
        return wrapper
    }

    buildForm(options) {
        let elements = []
        Object.entries(options).forEach((keyValue, index) => {
            elements.push(this.buildInput(keyValue[0], index + 1, keyValue[1]))
        })
        this.form = this.pollForm(elements)
        this.assignAjaxEvents()
        return this.form
    }

    addOptionInput() {
        this.inputs.append(this.renderOptionInput())
        this.setPlaceholders()
        this.assignDestroyEvents();
    }

    renderCreate() {
        for(let i = 0; i < 3; i++) {
            this.inputs.append(this.renderOptionInput(i))
        }
        this.setPlaceholders();
        this.assignDestroyEvents();
        this.setAction('create');
    }

    renderEdit() {
        this.setAction('create')
        this.pollShowWindow.empty();
        this.pollCreateWindow.show();
    }

    addAlert(error) {
        this.alertWindow.show();
        this.alertWindow.text(error)
        setTimeout(()=> { this.alertWindow.fadeOut(); }, 2000)
    }

    show() {
        this.setAction('show');
        this.pollCreateWindow.hide();
        this.pollShowWindow.append(this.buildForm(this.options));
    }
}