const express = require('express');
const mysql = require('mysql2');
const app = express();

app.use(express.json());

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') return res.sendStatus(204);
  next();
});

// Conexión a tu Workbench local
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'gymzone'
});

db.connect((err) => {
  if (err) {
    console.error('No se pudo conectar a MySQL (gymzone):', err.message);
    return;
  }
  console.log('Conectado a MySQL: gymzone');
});

db.on('error', (err) => console.error('Error de MySQL:', err.message));

app.get('/api/usuarios', (req, res) => {
  db.query('SELECT * FROM usuario', (err, results) => {
    if (err) return res.status(500).json({ error: 'No se pudieron consultar los usuarios', detail: err.message });
    res.status(200).json(results);
  });
});

app.post('/api/usuarios', (req, res) => {
  const { primer_nombre, primer_apellido, tipo_doc, num_doc, correo, password, rol, estado_cuenta } = req.body;
  if (!primer_nombre || !primer_apellido || !num_doc || !correo || !password) {
    return res.status(400).json({ error: 'Faltan datos obligatorios' });
  }
  const sql = `INSERT INTO usuario
    (primer_nombre, primer_apellido, tipo_doc, num_doc, correo, password, rol, estado_cuenta)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(sql, [primer_nombre, primer_apellido, tipo_doc || 'Cédula', num_doc, correo, password, rol || 'Cliente', estado_cuenta || 'Activo'], (err, result) => {
    if (err) return res.status(500).json({ error: 'No se pudo crear el usuario', detail: err.message });
    res.status(201).json({ idusuario: result.insertId, ...req.body });
  });
});

app.put('/api/usuarios/:id', (req, res) => {
  const { id } = req.params;
  const fields = Object.keys(req.body).filter((field) => ['primer_nombre', 'primer_apellido', 'tipo_doc', 'num_doc', 'correo', 'password', 'rol', 'estado_cuenta'].includes(field));
  if (!fields.length) return res.status(400).json({ error: 'No hay campos para actualizar' });
  const values = fields.map((field) => req.body[field]);
  db.query(`UPDATE usuario SET ${fields.map((field) => `${field} = ?`).join(', ')} WHERE idusuario = ?`, [...values, id], (err) => {
    if (err) return res.status(500).json({ error: 'No se pudo actualizar el usuario', detail: err.message });
    res.status(200).json({ ok: true });
  });
});

// Crea una preferencia de pago. Sin token de Mercado Pago se usa el checkout local de prueba.
app.post('/api/create-preference', async (req, res) => {
  const { items = [], payer = {} } = req.body;
  if (!Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: 'El carrito está vacío' });
  }

  const total = items.reduce((sum, item) => {
    const price = Number(item.unit_price) || 0;
    const quantity = Number(item.quantity) || 0;
    return sum + price * quantity;
  }, 0);

  if (total <= 0) {
    return res.status(400).json({ error: 'El total del pago no es válido' });
  }

  if (process.env.MP_ACCESS_TOKEN) {
    try {
      const response = await fetch('https://api.mercadopago.com/checkout/preferences', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${process.env.MP_ACCESS_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          items,
          payer: { email: payer.email },
          back_urls: {
            success: `${req.protocol}://${req.get('host')}/api/payment-success`,
            failure: `${req.protocol}://${req.get('host')}/api/payment-failure`,
            pending: `${req.protocol}://${req.get('host')}/api/payment-pending`,
          },
          auto_return: 'approved',
        }),
      });
      const data = await response.json();
      if (!response.ok) return res.status(response.status).json(data);
      return res.status(200).json({ urlDePago: data.init_point || data.sandbox_init_point });
    } catch (error) {
      return res.status(502).json({ error: 'No se pudo conectar con Mercado Pago', detail: error.message });
    }
  }

  const checkoutUrl = new URL(`${req.protocol}://${req.get('host')}/mock-payment`);
  checkoutUrl.searchParams.set('total', String(total));
  checkoutUrl.searchParams.set('email', payer.email || '');
  res.status(200).json({ urlDePago: checkoutUrl.toString(), simulated: true });
});

app.get('/mock-payment', (req, res) => {
  const total = Number(req.query.total) || 0;
  const email = String(req.query.email || '');
  res.type('html').send(`<!doctype html>
<html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Pago GymZone</title><style>
body{margin:0;background:#171719;color:#fff;font-family:Arial,sans-serif;display:grid;place-items:center;min-height:100vh}
main{width:min(440px,calc(100% - 32px));background:#222225;border:1px solid #3b3b3f;border-radius:12px;padding:24px;box-sizing:border-box}
h1{font-size:22px;margin:0 0 24px}strong{color:#a8e900}.total{font-size:28px;font-weight:bold;margin:20px 0}
button{width:100%;border:0;border-radius:8px;padding:15px;background:#a8e900;color:#111;font-weight:bold;font-size:16px;cursor:pointer}
.note{color:#aaa;font-size:13px;line-height:1.5}
</style></head><body><main><h1>CHECKOUT <strong>GYMZONE</strong></h1>
<p class="note">Modo de prueba local. No se realiza ningún cobro real.</p>
<div class="total">$${total.toLocaleString('es-CO')} COP</div><p class="note">Cliente: ${email}</p>
<button id="confirm-button" onclick="confirmPayment()">CONFIRMAR PAGO DE PRUEBA</button>
<p id="result" class="note"></p>
<script>
async function confirmPayment() {
  const button = document.getElementById('confirm-button');
  const result = document.getElementById('result');
  button.disabled = true;
  try {
    const response = await fetch('/api/mock-payment-success', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({email: ${JSON.stringify(email)}, total: ${JSON.stringify(total)}})
    });
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || 'No se pudo registrar el pago');
    button.textContent = 'PAGO CONFIRMADO';
    result.textContent = 'Pago realizado exitosamente. Ya puedes cerrar esta ventana.';
    result.style.color = '#a8e900';
  } catch (error) {
    button.disabled = false;
    result.textContent = error.message;
    result.style.color = '#ff7777';
  }
}
</script>
</main></body></html>`);
});

app.post('/api/mock-payment-success', (req, res) => {
  const { email, total } = req.body;
  if (!email || !total) {
    return res.status(400).json({ error: 'Faltan datos del pago' });
  }

  db.query('SELECT idusuario FROM usuario WHERE correo = ? LIMIT 1', [email], (findError, users) => {
    if (findError) return res.status(500).json({ error: 'No se pudo consultar el usuario', detail: findError.message });
    if (!users.length) return res.status(404).json({ error: 'No se encontró el usuario del pago' });

    const message = `Pago de prueba realizado exitosamente por $${Number(total).toLocaleString('es-CO')} COP.`;
    db.query(
      'INSERT INTO notificacion (usuario_id, mensaje) VALUES (?, ?)',
      [users[0].idusuario, `[Pago exitoso] ${message}`],
      (insertError, result) => {
        if (insertError) return res.status(500).json({ error: 'No se pudo guardar la notificación de pago', detail: insertError.message });
        res.status(201).json({ ok: true, id: result.insertId, message });
      },
    );
  });
});

// Endpoint para guardar la notificación
app.post('/api/notificaciones', (req, res) => {
  const { usuario_id, titulo, mensaje, broadcast } = req.body;
  const texto = titulo ? `[${titulo}] ${mensaje}` : mensaje;

  if (broadcast === true) {
    const query = 'SELECT idusuario FROM usuario';
    db.query(query, (err, rows) => {
      if (err) return res.status(500).json({ error: 'No fue posible obtener usuarios para notificación global', detail: err.message });
      const values = rows.map((user) => [user.idusuario, texto]);
      if (!values.length) {
        return res.status(201).json({ status: 'No hay usuarios para notificar' });
      }
      const sql = 'INSERT INTO notificacion (usuario_id, mensaje) VALUES ?';
      db.query(sql, [values], (insertErr) => {
        if (insertErr) return res.status(500).json({ error: 'No se pudo guardar la notificación global', detail: insertErr.message });
        res.status(201).json({ status: 'Notificación global guardada en Workbench' });
      });
    });
    return;
  }

  if (usuario_id === null || usuario_id === undefined) {
    return res.status(400).json({ error: 'La notificación necesita un usuario destinatario' });
  }

  const sql = 'INSERT INTO notificacion (usuario_id, mensaje) VALUES (?, ?)';
  db.query(sql, [usuario_id, texto], (err, result) => {
    if (err) return res.status(500).json(err);
    res.status(201).json({ status: 'Notificación guardada en Workbench', id: result.insertId });
  });
});

app.listen(3001, () => console.log('Servidor corriendo en puerto 3001'));

// Endpoint GET para obtener las notificaciones de un usuario por su ID
app.get('/api/notificaciones/:usuario_id', (req, res) => {
  const { usuario_id } = req.params;

  const query = 'SELECT * FROM notificacion WHERE usuario_id = ? ORDER BY id_notificacion DESC';

  db.query(query, [usuario_id], (err, results) => {
    if (err) {
      console.error('Error al consultar notificaciones:', err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    res.status(200).json(results);
  });
});

app.delete('/api/notificaciones/:usuario_id/:id', (req, res) => {
  const { usuario_id, id } = req.params;
  db.query(
    'DELETE FROM notificacion WHERE id_notificacion = ? AND usuario_id = ?',
    [id, usuario_id],
    (err, result) => {
      if (err) return res.status(500).json({ error: 'No se pudo borrar la notificación', detail: err.message });
      if (result.affectedRows === 0) return res.status(404).json({ error: 'Notificación no encontrada' });
      res.status(200).json({ ok: true });
    },
  );
});