//<?php
/**
 * Payment ExpressPay_EPOS
 *
 * Express-Pay: EPOS payments processing
 *
 * @category    plugin
 * @version     0.0.1
 * @author      OOO "TriIncom"
 * @internal    @events OnRegisterPayments,OnBeforeOrderSending
 * @internal    @properties &title=Название;text;Экспресс Платежи: E-POS &isTest=Использовать тестовый режим;list;Нет==0||Да==1; &serviceId=Номер услуги;text; &token=Токен;text; &eposCode=Код в EPOS;text; &useSignature=Использовать секретное слово для подписи счетов;list;Нет==0||Да==1; &secretWord=Секретное слово;text; &notifUrl=Адрес для получения уведомлений;text;https://домен вашего сайта/commerce/expresspay_epos/payment-process &useSignatureForNotif=Использовать цифровую подпись для уведомлений;list;Нет==0||Да==1; &secretWordForNotif=Секретное слово для уведомлений;text; &isNameEdit=Разрешено изменять ФИО;list;Нет==0||Да==1;&isAmountEdit=Разрешено изменять сумму;list;Нет==0||Да==1;&isAddressEdit=Разрешено изменять адрес;list;Нет==0||Да==1;&smsNotif=Отсылать уведомления плательщикам по SMS;list;Нет==0||Да==1;&emailNotif=Отсылать уведомления плательщикам по электронной почте;list;Нет==0||Да==1;0
 * @internal    @modx_category Commerce
 * @internal    @disabled 0
 * @internal    @installset base
*/

if (empty($modx->commerce) && !defined('COMMERCE_INITIALIZED')) {
    return;
}

$isSelectedPayment = !empty($order['fields']['payment_method']) && $order['fields']['payment_method'] == 'expresspay_epos';
$commerce = ci()->commerce;
$lang = $commerce->getUserLanguage('expresspay_epos');

switch ($modx->event->name) {
    case 'OnRegisterPayments': {
        $class = new \Commerce\Payments\ExpresspayEposPayment($modx, $params);

        if (empty($params['title'])) {
            $params['title'] = $lang['expresspay_epos.caption'];
        }

        $commerce->registerPayment('expresspay_epos', $params['title'], $class);
        break;
    }

    case 'OnBeforeOrderSending': {
        if ($isSelectedPayment) {
            $FL->setPlaceholder('extra', $FL->getPlaceholder('extra', '') . $commerce->loadProcessor()->populateOrderPaymentLink());
        }

        break;
    }
}
