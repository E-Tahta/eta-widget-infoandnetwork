all: install

install:
	mkdir -p $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/
	@cp -fr tr.org.etap.infoandnetwork $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/

	mkdir -p $(DESTDIR)/usr/share/kde4/services
	@cp -fr eta-widget-infoandnetwork.desktop $(DESTDIR)/usr/share/kde4/services/

uninstall:
	@rm -fr $(DESTDIR)/usr/share/kde4/services/eta-widget-infoandnetwork.desktop
	@rm -fr $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/tr.org.etap.infoandnetwork

.PHONY: install uninstall
