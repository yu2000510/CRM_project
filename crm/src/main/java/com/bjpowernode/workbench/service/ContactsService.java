package com.bjpowernode.workbench.service;

import com.bjpowernode.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactsByName(String cName);
}
