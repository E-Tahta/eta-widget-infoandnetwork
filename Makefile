all: install

install: i18n install-data

i18n:
	@msgfmt po/tr.po -o po/plasma_applet_tr.org.etap.infoandnetwork.mo

install-data:
	mkdir -p $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/
	@cp -fr tr.org.etap.infoandnetwork $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/

	mkdir -p $(DESTDIR)/usr/share/kde4/services
	@cp -fr eta-widget-infoandnetwork.desktop $(DESTDIR)/usr/share/kde4/services/

	mkdir -p $(DESTDIR)/usr/share/locale/tr/LC_MESSAGES
	@cp -fr po/*.mo $(DESTDIR)/usr/share/locale/tr/LC_MESSAGES/

uninstall:
	@rm -fr $(DESTDIR)/usr/share/kde4/services/eta-widget-infoandnetwork.desktop
	@rm -fr $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/tr.org.etap.infoandnetwork
	@rm -fr $(DESTDIR)/usr/share/locale/tr/LC_MESSAGES/plasma_applet_tr.org.etap.infoandnetwork.mo

.PHONY: i18n install uninstall

