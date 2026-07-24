using { anunbhav.cds as spiderman } from '../db/CDSView';


service CDSService @(path:'/cds') {
    entity POWorklist as projection on spiderman.CDSView.POWorklist;
       entity ProductView as projection on spiderman.CDSView.ProductView{
        *,
        virtual POCount : Integer
    };

    entity ItemView as projection on spiderman.CDSView.ItemView;
}
