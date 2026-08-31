# Geek Rice system persistence

`geek-rice-restore-system.sh` reapplies the selected SDDM and Plymouth configuration. `95-geek-rice-restore.hook` runs it after relevant package transactions.

The installer installs both files automatically. Manual installation is:

```bash
sudo install -Dm755 system/geek-rice-restore-system.sh /usr/local/bin/geek-rice-restore-system.sh
sudo install -Dm644 system/pacman-hooks/95-geek-rice-restore.hook /etc/pacman.d/hooks/95-geek-rice-restore.hook
sudo /usr/local/bin/geek-rice-restore-system.sh
```
