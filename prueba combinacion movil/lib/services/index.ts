// @ts-nocheck
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
interface NotificationRequest {
  fcmToken: string;
  eventType: 'REGISTER' | 'LOGIN' | 'ADD_TO_CART' | 'NEW_ORDER';
  details?: string;
}

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  try {
    const { fcmToken, eventType, details }: NotificationRequest = await req.json();

    if (!fcmToken) {
      return new Response(JSON.stringify({ error: 'FCM Token es requerido' }), { 
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    let title = '';
    let body = '';

    switch (eventType) {
      case 'REGISTER':
        title = '¡Bienvenido a la App! 🎉';
        body = 'Tu cuenta ha sido creada exitosamente. ¡Empieza a explorar!';
        break;
      case 'LOGIN':
        title = 'Inicio de sesión detectado 🔐';
        body = 'Se ha ingresado a tu cuenta recientemente.';
        break;
      case 'ADD_TO_CART':
        title = 'Producto agregado 🛒';
        body = details ? `Añadiste "${details}" al carrito.` : 'Añadiste un producto al carrito.';
        break;
      case 'NEW_ORDER':
        title = '¡Pedido Confirmado! 📦';
        body = details ? `Tu pedido #${details} está en proceso.` : 'Hemos recibido tu pedido correctamente.';
        break;
      default:
        title = 'Notificación de la App';
        body = 'Tienes una nueva actualización.';
    }

    const firebaseProjectId = Deno.env.get("FIREBASE_PROJECT_ID");
    const accessToken = Deno.env.get("FCM_ACCESS_TOKEN");

    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: fcmToken,
            notification: { title, body },
            data: { eventType }
          },
        }),
      }
    );

    const result = await response.json();
    return new Response(JSON.stringify({ success: true, result }), {
      headers: { "Content-Type": "application/json", 'Access-Control-Allow-Origin': '*' },
    });

  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), { 
      status: 500,
      headers: { "Content-Type": "application/json" }
    });
  }
});