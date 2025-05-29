// Contact Backend
function sendRequest() {

    // Backend Endpoint
    const endpoint = 'https://${ rest_api_id }.execute-api.us-east-1.amazonaws.com/v1/foo'

    // Build Query Parameters
    const params = {
        bar     : true,
        name    : document.getElementById('name').value,
        email   : document.getElementById('email').value,
        country : document.getElementById('country').value
    }

    // Remove Emptry Entries
    Object.keys(params).forEach(k => params[k] === '' && delete params[k])

    // Build Finial URL
    const url = `${ endpoint }?${ new URLSearchParams(params) }`

    // Perform Request
    fetch(new Request(url))
        .then(response => response.json())
        .then(data => {
            document.getElementById("json").innerHTML = JSON.stringify(data, undefined, 2);
        })
}

