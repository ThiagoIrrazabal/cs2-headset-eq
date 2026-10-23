---
name: cs2-headset-eq
description: Melhora o som de fone para ouvir passos no CS2 no Windows — instala o Equalizer APO, liga só na saída do fone (não no microfone) e aplica um preset que tira o grave abafado e realça 2-5 kHz. Use quando o usuário reclamar de som abafado, dificuldade de ouvir passos/posição no CS2 ou quiser reaplicar o EQ após trocar de fone ou formatar o PC.
---

# EQ de fone para CS2

Arquivos nesta pasta:
- `install.ps1` — instala o Equalizer APO se faltar (baixa do SourceForge e confere o MD5), faz backup do `config.txt` e aplica o preset. Precisa de administrador.
- `cs2-preset.txt` — o preset (grave -4 dB, 300 Hz -2 dB, 3 kHz +4 dB, 7 kHz +2 dB, preamp -5 dB).
- `README.md` — explicação para compartilhar.

## Passos

1. **Diagnóstico (só leitura).** Liste as saídas: `Get-PnpDevice -Class AudioEndpoint -PresentOnly`. Descubra se o fone é USB (placa de som própria) ou P2 (Realtek). Em `HKLM:\...\MMDevices\Audio\Render\{guid}\FxProperties`, veja se há efeitos do Windows ligados (equalização de altura, surround virtual). Se houver, sugira desligar.
2. **Peça permissão antes de instalar.** É um software de terceiros e a instalação mexe no driver de áudio.
3. **Rode o `install.ps1` em background** (`run_in_background`). O instalador abre a janela *Device Selector* e fica esperando o usuário. Se rodar em foreground, o terminal parece travado. Avise o usuário antes: na aba de reprodução (Playback), marcar **somente o fone**, nunca o microfone.
4. **Confira a saída do script.** Ela lista as saídas onde o APO está ativo (CLSIDs `{EACD2258-...}` Pre-Mix / `{EC1CC9CE-...}` Post-Mix no FxProperties).
5. **Diga o que fica com o usuário:** reiniciar o PC, deixar o CS2 com Perfil de EQ **"Crisp"** e o som espacial do Windows **desativado**.

## Ajuste fino

O `config.txt` (`C:\Program Files\EqualizerAPO\config\config.txt`) vale na hora, sem reiniciar. Ajuste em passos de 1 a 2 dB:
- **Ainda abafado:** aumente o filtro de 3 kHz (até +6 dB) ou reduza mais o grave.
- **Chiado ou cansativo:** reduza os filtros de 7 kHz e 3 kHz.
- **Distorcendo:** o preamp precisa ser pelo menos tão negativo quanto o maior ganho positivo.

Se mudar o preset, atualize também o `cs2-preset.txt` desta pasta.

## Desfazer

- Voltar ao config original: copie `config_original.txt` por cima de `config.txt`.
- Remover tudo: desinstale "Equalizer APO" pelo Painel de Controle e reinicie.
