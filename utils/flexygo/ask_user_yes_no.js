flexygo.msg.confirm('¿Estás seguro?').then((result) => {
    if (result) {
        flexygo.msg.alert('Confirmado');
    } else {
        flexygo.msg.alert('Cancelado');
    }
});