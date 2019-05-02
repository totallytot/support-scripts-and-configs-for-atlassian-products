import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def send_email(expiration_days):
        fromaddr = "example@example.com"
        list = ['example@example.com']
        toaddr = '; '.join(list)

        msg = MIMEMultipart()
        msg['From'] = fromaddr
        msg['To'] = toaddr
        msg['Subject'] = "Atlassian Expiration Licenses"
        body = "Atlassian Applications Licenses will be expired in: {} days".format(expiration_days)
        msg.attach(MIMEText(body, 'plain'))

        server = smtplib.SMTP('smtp.example.com', 587)
        server.ehlo
        server.starttls()
        server.login("user", "pass")
        text = msg.as_string()
        server.sendmail(fromaddr, list, text)
        server.quit()
