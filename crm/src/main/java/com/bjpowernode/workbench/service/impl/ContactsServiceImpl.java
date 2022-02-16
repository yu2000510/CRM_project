package com.bjpowernode.workbench.service.impl;

import com.bjpowernode.workbench.dao.ContactsDao;
import com.bjpowernode.workbench.domain.Contacts;
import com.bjpowernode.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;

    @Override
    public List<Contacts> getContactsByName(String cName) {
        List<Contacts> cList = contactsDao.getContactsByName(cName);
        return cList;
    }
}
